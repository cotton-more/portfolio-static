# Menu controller
PortfolioCtrl = ($scope, Portfolio) ->
    $scope.list = Portfolio.projects()
    return

PortfolioCtrl.$inject = ['$scope', 'Portfolio']
angular.module('portfolioNgApp').controller 'PortfolioCtrl', PortfolioCtrl


# List project's cards
CardListCtrl = ($scope, $routeParams, baseUrl, Portfolio) ->
    menuId = parseInt $routeParams.menuId, 10
    $scope.baseUrl = baseUrl
    $scope.cards = Portfolio.cards {
        id: menuId
    }


CardListCtrl.$inject = ['$scope', '$routeParams', 'baseUrl', 'Portfolio']
angular.module('portfolioNgApp').controller 'CardListCtrl', CardListCtrl
