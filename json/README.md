# Json sample

responds to following json calls:

    /posts                             PostsR    GET POST
    /posts/#PostId                     PostR     GET PUT DELETE

    /posts/#PostId/comments            CommentsR GET POST
    /posts/#PostId/comments/#CommentId CommentR  GET PUT DELETE

example calls:

    $ curl -H 'Content-Type: application/json' -X GET http://localhost:3000/posts
    {"posts":[]}

    $ curl -H 'Content-Type: application/json' -X POST -d '{ "id": 1, "title": "title 1", "content": "content 1" }' http://localhost:3000/posts

    $ curl -H 'Content-Type: application/json' -X GET http://localhost:3000/posts
    {"posts":[{"content":"content 1","id":"1","title":"title 1"}]}

    curl -H 'Content-Type: application/json' -X POST -d '{ "id": 1, "post_id": 1, "content": "comment content 1" }' http://localhost:3000/posts/1/comments

    $ curl -H 'Content-Type: application/json' -X GET http://localhost:3000/posts/1/comments
    {"comments":[{"post_id":"1","content":"comment content 1","id":"1"}]}

    $ curl -H 'Content-Type: application/json' -X PUT -d '{ "id": 1, "post_id": 1, "content": "comment content 1 modified" }' http://localhost:3000/posts/1/comments/1

    $ curl -H 'Content-Type: application/json' -X GET http://localhost:3000/posts/1/comments/1
    {"comment":{"post_id":"1","content":"comment content 1 modified","id":"1"}}

    $ curl -H 'Content-Type: application/json' -X DELETE http://localhost:3000/posts/1/comments/1

    $ curl -H 'Content-Type: application/json' -X GET http://localhost:3000/posts/1/comments
    {"comments":[]}

    $ curl -H 'Content-Type: application/json' -X DELETE http://localhost:3000/posts/1

    $ curl -H 'Content-Type: application/json' -X GET http://localhost:3000/posts
    {"posts":[]}
