angular.module('portfolioApp', [
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
                templateUrl: 'tpl/portfolio/portfolio.html'
            .when '/portfolio/projects/new',
                templateUrl: 'tpl/portfolio/project-new.html'
                controller: 'ProjectNewCtrl'
                authOnly: true
            .when '/portfolio/projects/:id',
                templateUrl: 'tpl/portfolio/cardsList.html'
                controller: 'CardListCtrl'
            .when '/portfolio/projects/:id/edit',
                templateUrl: 'tpl/portfolio/project-edit.html'
                controller: 'ProjectEditCtrl'
                authOnly: true
            .otherwise
                redirectTo: '/index'

        $locationProvider.html5Mode(off).hashPrefix('!')
        return

    .constant('baseUrl', '/index')
