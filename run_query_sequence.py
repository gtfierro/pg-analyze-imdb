import re
import sys
import os
import tempfile
import subprocess

from pygments import highlight
from pygments.lexers.sql import PostgresLexer
from pygments.formatters import Terminal256Formatter
from pprint import pformat

def printsql(q):
    print(highlight(q, PostgresLexer(), Terminal256Formatter()))

if len(sys.argv) < 2:
    print("Usage: python split_queries.py <queries.sql>")
    sys.exit(1)

f = open(sys.argv[1]).read()
for query in f.split(';'):
    os.system('clear')
    printsql(re.sub('^SELECT', 'EXPLAIN ANALYZE SELECT', query, flags=re.M))
    # if 'SELECT' in query and not 'LIMIT' in query:
    #     query = query.strip(';') + " LIMIT 1000;"
    # paste query w/o EXPLAIN into some file and copy into clipboard
    with tempfile.NamedTemporaryFile(mode='w') as tf:
        tf.write(query)
        tf.flush()
        subprocess.run(f'cat {tf.name} | xclip -sel clip', shell=True)

    if not ('DROP' in query or 'CREATE' in query):
        query = "SET max_parallel_workers_per_gather = 0; SET jit = off; EXPLAIN ANALYZE \n" + query
        # query = "EXPLAIN ANALYZE \n" + query
    with tempfile.NamedTemporaryFile(mode='w') as tf:
        tf.write(query)
        tf.flush()
        print("Running...")
        output = subprocess.run(f'psql -h localhost -U postgres imdb -f {tf.name}',
                                shell=True, capture_output=True,
                                env={'PGPASSWORD': 'cs186'})
        print("Done!")
        print(output.stdout.decode('utf8'))
        input()
