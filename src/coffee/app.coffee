angular.module('portfolioNgApp', ['ngResource', 'ui.bootstrap', 'ui.bootstrap.tpls'])
    .config ($routeProvider, $locationProvider, baseUrl) ->
        $routeProvider
            .when baseUrl,
                templateUrl: 'views/portfolio.html'
            .when '/project/:menuId/view',
                templateUrl: 'views/cardsList.html'
                controller: 'CardListCtrl'
            .otherwise
                redirectTo: baseUrl

        $locationProvider.html5Mode(off).hashPrefix('!')
        return

    .constant('baseUrl', '/index')
