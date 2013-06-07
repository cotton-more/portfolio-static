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
    #$scope.project = Portfolio.active()

    Portfolio.onProjectLoaded $scope, (projects) ->
        angular.forEach projects, (project) ->
            if project.id is projectId
                $scope.project = project
        return

    $scope.edit = (project) ->
        console.log project

    return


CardListCtrl.$inject = ['$scope', '$routeParams', 'baseUrl', 'Portfolio']
angular.module('portfolioNgApp').controller 'CardListCtrl', CardListCtrl
