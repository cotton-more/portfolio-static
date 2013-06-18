angular.module('portfolioApp')
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


angular.module('portfolioApp')
    .controller 'ProjectController', ($scope, $location, Portfolio) ->

        Portfolio.onProjectLoaded $scope, (data) ->
            updateItems = (items) ->
                angular.forEach items, (item) ->
                    item.active = 0 is $location.$$path.indexOf item.url

            updateItems data

            $scope.$on '$routeChangeSuccess', ->
                updateItems data

        $scope.selectProject = (item) ->
            Portfolio.selectProject item

angular.module('portfolioApp')
    .directive 'niProjectList', ->
        niProjectList =
            controller: 'ProjectController'
            templateUrl: 'views/project-list.html'
            replace: true
            restrict: 'M'

        return niProjectList


angular.module('portfolioApp')
    .directive 'slider', ->
        orbit =
            controller: ['$scope', '$element', '$attrs', ($scope, $element, $attrs) ->
                @slider = $element
                return
            ]

angular.module('portfolioApp')
    .directive 'slide', ($timeout) ->
        slide =
            restrict: 'A'
            require: '^slider'
            link: ($scope, $element, $attrs, $controller) ->
                if ($scope.$last)
                    $($controller.slider).foundation('orbit')
