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
    .directive 'niCard', ->
        template = """
        <div class="card">
            <h4 class="title">{{card.name}}</h4>
            <img src="http://placehold.it/600x480/&text={{card.name}}">
            <p>{{card.about}}</p>
        </div>
        """
        niCard =
            restrict: 'M'
            replace: true
            template: template
            link: (scope) ->
                if scope.$last
                    $('#cards-list').foundation 'orbit', {
                        bullets: off
                        slide_number: off
                    }

        return niCard


angular.module('portfolioNgApp').controller 'ProjectItemController', ['$scope', 'Portfolio', ($scope, Portfolio) ->
    $scope.select = (item) ->
        Portfolio.active item
]


angular.module('portfolioNgApp')
    .directive 'niProjectList', ->
        niProjectList =
            templateUrl: 'views/project-list.html'
            controller: 'ProjectItemController'
            replace: true
            restrict: 'M'

        return niProjectList
