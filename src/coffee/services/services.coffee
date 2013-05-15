angular.module('portfolioNgApp')
    .factory 'Persona', ['$http','$rootScope', ($http, $rootScope) ->
        STATUS = 'Email of logged in user'

        _email = undefined

        _status = ->
            console.log '_status'
            $http.jsonp('http://localhost:8000/auth/email?callback=JSON_CALLBACK')
                .success (data)->
                    console.log 'get email', data
                    $rootScope.$broadcast STATUS, data
                    navigator.id.watch
                        loggedInUser: data.email
                        onlogin: (assertion) ->
                            console.log 'onlogin'
                            $http.jsonp('http://localhost:8000/auth/login',
                                params:
                                    callback: 'JSON_CALLBACK'
                                    assertion: assertion
                            ).success (data)->
                                console.log 'verifyAssertion.success', data
                                $rootScope.$broadcast STATUS, data
                        onlogout: ->
                            console.log 'onlogout'
                            $http.jsonp('http://localhost:8000/auth/logout?callback=JSON_CALLBACK')
                                .success (data)->
                                    console.log 'auth/logout', data
                                    $rootScope.$broadcast STATUS, data


        Persona = {}

        Persona.onStatus = ($scope, handle) ->
            console.log 'Persona.onStatus', arguments

            $scope.$on STATUS, (event, message) ->
                console.log 'Persona.onStatus.$on', arguments
                _email = message.email
                handle message

            _status()

        Persona.request = ->
            console.log 'request'
            navigator.id.request()

        Persona.signout = ->
            console.log 'signout'
            navigator.id.logout()

        Persona.email = ->
            _email

        Persona
    ]

angular.module('portfolioNgApp')
    .factory 'User', ['$http', '$rootScope', ($http) ->

        authToken = null
        isAuthenticated = false

        User = {}

        User.getEmail = ->
            'vansanblch@gmail.com'

        User.isAuthenticated = ->
            return isAuthenticated

        User.login = ->
            $http.post

        User
    ]

angular.module('portfolioNgApp')
    .factory 'Menu', ['$resource', '$http', '$rootScope', ($resource, $http, $rootScope) ->
        keepGoing = true
        tree = []
        menu = []

        MenuService =
            currentMenu: false

        TREE_LOADED = 'treeLoaded'
        CARDS_LOADED = 'cardsLoaded'

        pushChild = (item, to = tree) ->
            if item.parent_id is null
                to.push item
            else
                angular.forEach to, (value) ->
                    if keepGoing
                        if value.id is item.parent_id
                            keepGoing = false
                            value.children.push item
                        else
                            pushChild item, value.children

        MenuService.getTree = ->
            return tree if tree.length

            uri = 'http://localhost\\:5000/menu/:action'
            $resource( uri ).query {action: 'list'}, (data) ->
                menu = data.result
                angular.forEach data.result, (item) ->
                    item.children = []
                    keepGoing = true
                    pushChild item
                $rootScope.$broadcast(TREE_LOADED, menu)

            tree

        MenuService.onMenuLoaded = ($scope, handle) ->
            $scope.$on TREE_LOADED, (event, message) ->
                handle message

        MenuService.onCardsLoaded = ($scope, handle) ->
            $scope.$on CARDS_LOADED, (event, message) ->
                handle message

        MenuService.getCards = (menuId, callback) ->
            if not angular.isFunction callback
                callback = angular.noop

            $resource(
                'http://localhost\\:8000/get_cards/:menuId',
                {callback: 'JSON_CALLBACK'},
                query: {method: 'JSONP'}
            ).query {menuId: menuId}, callback

        MenuService.save = (menu) ->
            menuId = menu.id
            $http.jsonp 'http://localhost\\:8000/menu/:id/save', 
                id: 'test'
                params: menu

        MenuService
    ]
