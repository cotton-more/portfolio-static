angular.module('portfolioApp.directives', [])
    .directive('projectList', ->
        ProjectList =
            controller: [
                '$scope'
                'Portfolio'
                'security'
                ($scope, Portfolio, security) ->
                    $scope.isAuthenticated = security.isAuthenticated

                    $scope.projects = Portfolio.loadProjects()

                    $scope.selectProject = (project) ->
                        Portfolio.currentProject project
            ]
            templateUrl: 'portfolio/project-list.html'
            replace: true
            restrict: 'M'

        return ProjectList
    )

    .directive('slider', ->
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
    )

    .directive('slide', ->
        slide =
            restrict: 'A'
            require: '^slider'
            link: ($scope, $element, $attrs, $controller) ->
                if $scope.$first
                    $controller.select $scope.card

                if $scope.$last
                    $($controller.slider).foundation 'orbit'
    )
