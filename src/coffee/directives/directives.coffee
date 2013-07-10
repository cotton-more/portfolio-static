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
