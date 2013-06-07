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
    .factory 'Security', (Persona) ->
        Security = {}

        return Security


angular.module('portfolioNgApp')
    .factory 'Portfolio', ($resource, $http, $rootScope) ->

        active = undefined


        uri = 'http://127.0.0.1\\:5000/portfolio/:listController:id/:docController'
        portfolio = $resource uri, { }, {
            projects:
                method: 'GET'
                isArray: false
                params: { listController: 'projects' }
            cards:
                method: 'GET'
                isArray: false
                params: { id: '@id', docController: 'cards' }
        }


        Portfolio = {}


        Portfolio.getProjects = ->
            portfolio.projects ((data) ->
                projects = data.result
            )


        Portfolio.getCards = (projectId) ->
            portfolio.cards {
                id: projectId
            }


        Portfolio.active = (project = undefined) ->
            return active if project is undefined and active

            active = project

        return Portfolio

