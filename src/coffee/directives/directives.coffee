angular.module('portfolioApp')
    .controller 'ProjectController', ($scope, $location, Portfolio, security) ->
        $scope.isAuthenticated = security.isAuthenticated
        $scope.projects = Portfolio.getProjects()
        $scope.selectProject = (item) ->
            Portfolio.selectProject item

angular.module('portfolioApp')
    .directive 'projectList', ->
        ProjectList =
            controller: 'ProjectController'
            templateUrl: 'views/project-list.html'
            replace: true
            restrict: 'M'

        return ProjectList


angular.module('portfolioApp')
    .directive 'slider', ->
        orbit =
            scope:
                cards: '=slider'
            controller: ['$scope', '$element', '$attrs', ($scope, $element, $attrs) ->
                @select = (card) ->
                    $scope.card = card

                @slider = $element

                $element.on 'orbit:after-slide-change', (ev, orbit) ->
                    angular.forEach $scope.cards, (card, i) ->
                        if orbit.slide_number is (++i)
                            $scope.$apply ->
                                $scope.card = card

                return
            ]

angular.module('portfolioApp')
    .directive 'slide', ->
        slide =
            restrict: 'A'
            require: '^slider'
            link: ($scope, $element, $attrs, $controller) ->
                if $scope.$first
                    $controller.select $scope.card

                if $scope.$last
                    $($controller.slider).foundation 'orbit'
