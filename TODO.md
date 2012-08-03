========
To Do
========

1. API for modules
2. Integration with bttrack so that we have stats and can automatically add torrents
3. Other database types (MySQL, PostgreSQL, MongoDB, Redis, etc)
4. SSL


## API necessities

Hook registers must accept a function reference as a parameter, in Python it would look like:
<pre>
def accept_data():
	do_stuff

register_hook_callback(accept_data)
</pre>

and the hook would be able to call accept_data because all functions are higher-order in Python. In Ruby it is not that simple but still must be done.
