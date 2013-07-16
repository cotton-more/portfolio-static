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
