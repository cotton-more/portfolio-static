angular.module('portfolioNgApp', ['ngResource', 'ui.bootstrap.tpls'])
    .config ($routeProvider, $locationProvider) ->
        $routeProvider
            .when '/',
                templateUrl: 'views/index.html'
            .when '/menu/:menuId/edit',
                templateUrl: '/views/menu_edit.html'
                controller: 'MenuEditCtrl'
            .when '/menu/:menuId/cards',
                templateUrl: '/views/menu_cards.html'
                controller: 'CardListCtrl'
            .otherwise
                redirectTo: '/'

        $locationProvider.html5Mode(off).hashPrefix('!')
