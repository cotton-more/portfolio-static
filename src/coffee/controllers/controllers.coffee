# Menu controller
PortfolioCtrl = ($scope, Portfolio) ->
    $scope.list = Portfolio.getProjects()
    return

PortfolioCtrl.$inject = ['$scope', 'Portfolio']
angular.module('portfolioNgApp').controller 'PortfolioCtrl', PortfolioCtrl


# List project's cards
CardListCtrl = ($scope, $routeParams, baseUrl, Portfolio) ->
    projectId = parseInt $routeParams.menuId, 10
    $scope.baseUrl = baseUrl
    $scope.cards = Portfolio.getCards projectId

    $scope.project = Portfolio.selectedProject()

    Portfolio.onProjectLoaded $scope, (projects) ->
        angular.forEach projects, (project) ->
            if project.id is projectId
                $scope.project = Portfolio.selectProject project

    return


CardListCtrl.$inject = ['$scope', '$routeParams', 'baseUrl', 'Portfolio']
angular.module('portfolioNgApp').controller 'CardListCtrl', CardListCtrl
