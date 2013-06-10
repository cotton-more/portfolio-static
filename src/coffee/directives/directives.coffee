angular.module('portfolioNgApp')
    .directive 'niPersonaAuth', (Persona, $compile) ->

        authTmpl = '<a><img class="persona" ng-click="request()" src="/static/images/plain_sign_in_black.png"></a>'
        userTmpl = """
            <a>{{email}} <span ng-click="signout()">Sign out</span>
        """

        niPersonaAuth =
            template: '<li class="persona"><a>Persona</a></li>'
            restrict: 'M'
            replace: true


        niPersonaAuth.link = (scope, element) ->
            scope.request = ->
                Persona.request()

            scope.signout = ->
                Persona.signout()

            Persona.onStatus scope, (message) ->
                if message.email
                    scope.email = message.email
                    template = userTmpl
                else
                    template = authTmpl

                element.html template

                $compile(element.contents())(scope)

        niPersonaAuth


angular.module('portfolioNgApp')
    .controller 'ProjectController', ($scope, $routeParams, Portfolio) ->
        $scope.selectProject = (item) ->
            Portfolio.selectProject item

angular.module('portfolioNgApp')
    .directive 'niProjectList', ->
        niProjectList =
            controller: 'ProjectController'
            templateUrl: 'views/project-list.html'
            replace: true
            restrict: 'M'

        return niProjectList
