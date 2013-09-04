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
                resolve:
                    project: ['Portfolio', '$route', '$q', (Portfolio, $route, $q) ->
                        deferred = $q.defer()

                        id = +$route.current.params.id

                        if Portfolio.projects.data
                            angular.forEach Portfolio.projects.data, (project) ->
                                if project.id is id
                                    deferred.resolve project
                        else
                            Portfolio.loadProjects (result) ->
                                angular.forEach result.data, (project) ->
                                    if project.id is id
                                        deferred.resolve project

                        deferred.promise
                    ]
            .when '/projects/:id/edit',
                templateUrl: 'portfolio/project-edit.html'
                controller: 'ProjectEditCtrl'
                authOnly: true
            .otherwise
                redirectTo: '/index'

        $locationProvider.html5Mode(off).hashPrefix('!')
        return

    .constant('baseUrl', '/index')
