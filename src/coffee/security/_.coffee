angular.module('security', ['security.service', 'security.login'])
    .run ['security', (security) ->
        security.checkUser()
    ]
