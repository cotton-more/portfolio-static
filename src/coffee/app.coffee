angular.module('portfolioNgApp', ['ngResource', 'ui.bootstrap', 'ui.bootstrap.tpls'])
    .config ($routeProvider, $locationProvider, baseUrl) ->
        $routeProvider
            .when '/index',
                templateUrl: 'views/portfolio.html'
            .when '/project/:id/view',
                templateUrl: 'views/cardsList.html'
                controller: 'CardListCtrl'
            .when '/project/:id/edit',
                templateUrl: 'views/project-edit.html'
                controller: 'ProjectEditCtrl'
            .otherwise
                redirectTo: '/index'

        $locationProvider.html5Mode(off).hashPrefix('!')
        return

    .constant('baseUrl', '/index')
