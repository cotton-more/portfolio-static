angular.module('security', ['security.service', 'security.login'])
    .run ['security', '$rootScope', (security, $rootScope) ->
        security.checkUser()
        $rootScope.$on '$routeChangeStart', (ev, next, current) ->
            if next.authOnly
                next.resolve =
                    auth: ['$q', ($q) ->
                        deferred = $q.defer()

                        if security.isAuthenticated()
                            deferred.resolve()
                        else
                            deferred.reject 'Auth required.'

                        deferred.promise
                    ]
    ]

angular.module('security')
    .directive 'auth', ['security', (security) ->
        directive =
            restrict: 'A'
            scope: true
            controller: ['$scope', '$element', ($scope, $el) ->
                $scope.$watch ->
                    security.currentUser
                , ->
                    if security.isAuthenticated()
                        $el.show()
                    else
                        $el.hide()
            ]

        return directive
    ]
