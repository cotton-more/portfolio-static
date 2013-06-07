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
    $scope.project = Portfolio.active()
    return


CardListCtrl.$inject = ['$scope', '$routeParams', 'baseUrl', 'Portfolio']
angular.module('portfolioNgApp').controller 'CardListCtrl', CardListCtrl
