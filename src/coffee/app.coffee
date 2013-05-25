angular.module('portfolioNgApp', ['ngResource', 'ui.bootstrap', 'ui.bootstrap.tpls'])
    .config ($routeProvider, $locationProvider, baseUrl) ->
        $routeProvider
            .when baseUrl,
                templateUrl: 'views/portfolio.html'
            .when '/menu/:menuId/edit',
                templateUrl: '/views/menu_edit.html'
                controller: 'MenuEditCtrl'
            .when baseUrl + '/:menuId/cards',
                templateUrl: 'views/cardsList.html'
                controller: 'CardListCtrl'
            .otherwise
                redirectTo: baseUrl

        $locationProvider.html5Mode(on)
        return

    .constant('baseUrl', '/portfolio')
