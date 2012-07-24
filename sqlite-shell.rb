#!/usr/bin/ruby
# -*- coding: utf-8 -*-

## sqlite-shell.rb
## Copyright (C) 2010 Christian Höltje -- http://docwhat.org
## URL: http://github.com/docwhat/sqlite-shell.rb
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'sqlite3'
require 'readline' rescue LoadError
require 'abbrev'

is_libedit = false
begin
  Readline.emacs_editing_mode
rescue NotImplementedError
  is_libedit = true
end

raise "You must specify the sqlite file to open." if (db_path = ARGV[0]).nil?

SPECIALS = %w[SELECT UPDATE INSERT CREATE DROP DELETE .headers .exit .quit .tables .help .schema].abbrev
HIST_FILE = File.expand_path("~/.sqlite_history")
SEP = '|'

class MyDatabase < SQLite3::Database
  def query string, *bind_vars
    if string.strip.start_with? '.'
      return special(string)
    end

    prepare string do |stmt|
      puts stmt.columns.join(SEP) if @use_headers
      stmt.execute(*bind_vars) do |result|
        result.each do |x|
          puts x.join(SEP)
        end
      end
    end
    return true
  end

  def complete? string, utf16=false
    if string.strip.start_with? '.'
      return true
    else
      return super(string)
    end
  end

  def special string
    args = string.split(/\s+/,2)
    command = args[0].strip
    option  = args.length > 1 ? args[1].strip : ''
    if [ '.quit', '.exit' ].include? command
      exit 0
    elsif command == '.tables'
      if option.length > 0
        query "SELECT name FROM sqlite_master WHERE type='table' AND name LIKE ? ORDER BY name;", option
      else
        query "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;"
      end
    elsif command == '.schema'
      if option.length > 0
        query "SELECT sql FROM sqlite_master WHERE type = 'table' AND name LIKE ? ORDER BY name;", option
      else
        query "SELECT sql FROM sqlite_master WHERE type = 'table' ORDER BY name;"
      end
    elsif ['.header','.headers'].include?(command) and option.upcase == 'ON'
        @use_headers = true
    elsif ['.header','.headers'].include?(command) and option.upcase == 'OFF'
        @use_heaers = false
    elsif command == '.help'
      puts "
.exit                  Exit this program
.quit                  Exit this program
.header(s) ON|OFF      Turn display of headers on or off
.tables ?TABLE?        List names of tables
                         If TABLE specified, only list tables matching
                         LIKE pattern TABLE.
.schema ?TABLE?        Show the CREATE statements
                         If TABLE specified, only show tables matching
                         LIKE pattern TABLE.
"
    else
      raise SQLite3::MisuseException.new "Try using .help"
    end
  end
end

# Set up readline
Readline.completion_append_character = " "
Readline.completion_proc = proc do |string|
  puts "NARF #{string}"
  list = SPECIALS.values.grep(/^#{Regexp.escape(string)}/).sort.uniq
  is_libedit ? list.collect { |i| i += ' ' } : list
end

# Read the history.
if File.exists? HIST_FILE
  File.open(HIST_FILE, 'r') do |f|
    f.readlines.each { |line| Readline::HISTORY.push line.chomp }
  end
end


### MAIN ###
db = MyDatabase.new(db_path)

NORMAL_PROMPT  = "sqlite> "
PENDING_PROMPT = "   ...> "

begin
  command_store = []
  while buf = Readline.readline(command_store.length > 0 ? PENDING_PROMPT : NORMAL_PROMPT)
    command_store << buf
    buf = command_store.join(' ')

    if db.complete? buf
      command_store = []

      # Execute the SQL
      begin
        db.query buf
        Readline::HISTORY.push buf.strip.sub(/\s+;$/, ';')
      rescue SQLite3::MisuseException => err
        puts "ERROR Invalid Syntax"
      rescue SQLite3::Exception => err
        puts "ERROR #{err.class}: #{err}"
        puts "Your SQL:"
        puts "   #{buf}"
      end
    end
  end
ensure
  puts "Exiting."
  File.open(HIST_FILE, 'w') do |f|
    Readline::HISTORY.each { |line|
      f.puts line
    }
  end
end

# EOF
