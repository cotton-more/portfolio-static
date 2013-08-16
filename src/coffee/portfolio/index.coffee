angular.module('portfolioApp', [
    'ngRoute'
    'ngResource'
    'portfolioApp.tpls'
    'portfolioApp.controllers'
    'portfolioApp.services'
    'portfolioApp.directives'
    'security'
])
    .config ($routeProvider, $locationProvider) ->
        $routeProvider
            .when '/index',
                templateUrl: 'portfolio/portfolio.html'
            .when '/projects/new',
                templateUrl: 'portfolio/project-new.html'
                controller: 'ProjectNewCtrl'
                authOnly: true
            .when '/projects/:id',
                templateUrl: 'portfolio/cardsList.html'
                controller: 'CardListCtrl'
            .when '/projects/:id/edit',
                templateUrl: 'portfolio/project-edit.html'
                controller: 'ProjectEditCtrl'
                authOnly: true
            .otherwise
                redirectTo: '/index'

        $locationProvider.html5Mode(off).hashPrefix('!')
        return

    .constant('baseUrl', '/index')
