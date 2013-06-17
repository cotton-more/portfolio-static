angular.module('portfolioApp')
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


angular.module('portfolioApp')
    .factory 'Portfolio', ($resource, $rootScope, Persona) ->

        PROJECTS_LOADED = 'Projects loaded'


        projects = []
        _currentProject = null


        uri = 'http://127.0.0.1\\:5000/portfolio/:listController:id/:docController'
        $portfolio = $resource uri


        Portfolio = {}


        Portfolio.save = (model) ->
            model.$save {
                listController: 'projects'
                docController: 'save'
            }


        Portfolio.getProjects = ->
            projects = $portfolio.query({
                listController: 'projects'
            }, (data)->
                $rootScope.$broadcast PROJECTS_LOADED, data
            )

        Portfolio.getProject = (id) ->
            _currentProject = $portfolio.get({
                listController: 'projects'
                docController: id
            })


        Portfolio.currentProject = ->
            _currentProject


        Portfolio.onProjectLoaded = ($scope, handle) ->
            console.log 'Portfolio.onProjectLoaded'

            $scope.$on PROJECTS_LOADED, (event, message) ->
                handle message


        Portfolio.selectProject = (project) ->
            angular.forEach projects, (item) ->
                item.active = project is item
            return


        return Portfolio
