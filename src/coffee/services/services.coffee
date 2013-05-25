angular.module('portfolioNgApp')
    .factory 'Persona', ($http, $rootScope) ->
        STATUS = 'Email of logged in user'

        _email = undefined

        navigator.id.watch
            onlogin: (assertion) ->
                console.log 'onlogin', assertion
                $http.get('http://127.0.0.1:5000/users/login',
                    params:
                        assertion: assertion
                ).success (data)->
                    console.log 'verifyAssertion.success', data
                    $rootScope.$broadcast STATUS, data
                return
            onlogout: ->
                console.log 'onlogout'
                $http.get('http://127.0.0.1:5000/users/logout')
                    .success (data)->
                        console.log 'auth/logout', data
                        $rootScope.$broadcast STATUS, data
                return

        _status = ->
            console.log '_status'
            $http.get('http://127.0.0.1:5000/users/email')
                .success (data)->
                    console.log 'get email', data
                    $rootScope.$broadcast STATUS, data
            return


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

angular.module('portfolioNgApp')
    .factory 'Security', ()

angular.module('portfolioNgApp')
    .factory 'User', (Security) ->


        User

angular.module('portfolioNgApp')
    .factory 'Menu', ($resource, $http, $rootScope) ->
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

            uri = 'http://127.0.0.1\\:5000/portfolio/menu/:action'
            $resource(
                uri,
                {},
                query:
                    method: 'GET'
                    isArray: false
            ).query {action: 'list'}, (data) ->
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
                'http://127.0.0.1\\:5000/portfolio/get_cards/:menuId',
                {},
                query:
                    method: 'GET'
                    isArray: false
            ).query {menuId: menuId}, callback

        MenuService.save = (menu) ->
            menuId = menu.id
            $http.jsonp 'http://127.0.0.1\\:5000/portfolio/menu/:id/save', 
                id: 'test'
                params: menu

        MenuService
