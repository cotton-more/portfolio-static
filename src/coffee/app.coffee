angular.module('portfolioApp', ['ngResource', 'portfolioApp.tpls', 'security'])
    .config ($routeProvider, $locationProvider) ->
        $routeProvider
            .when '/index',
                templateUrl: 'views/portfolio.html'
            .when '/portfolio/projects/new',
                templateUrl: 'views/project-new.html'
                controller: 'ProjectNewCtrl'
                authOnly: true
            .when '/portfolio/projects/:id',
                templateUrl: 'views/cardsList.html'
                controller: 'CardListCtrl'
            .when '/portfolio/projects/:id/edit',
                templateUrl: 'views/project-edit.html'
                controller: 'ProjectEditCtrl'
                authOnly: true
            .otherwise
                redirectTo: '/index'

        $locationProvider.html5Mode(off).hashPrefix('!')
        return

    .constant('baseUrl', '/index')
