angular.module('portfolioApp.services', [])
    .factory('Portfolio', ($resource, $rootScope) ->

        PROJECTS_LOADED = 'Projects loaded'


        _currentProject = null


        # uri = 'http://127.0.0.1\\:5000/api/:listController/:id/:docController'
        # $portfolio = $resource uri
        Projects = $resource 'http://127.0.0.1\\:5000/api/projects/:id/:verb', {}, {
            all:
                method: 'GET'
                isArray: false
        }

        Cards = $resource 'http://127.0.0.1\\:5000/api/projects/:id/cards', {}, {
            query:
                method: 'GET'
                isArray: false
        }


        Portfolio =
            projects: null


        Portfolio.save = (model) ->
            model.$save {
                listController: 'projects'
                docController: 'save'
            }


        Portfolio.loadProjects = ->
            Portfolio.projects = Projects.all()

        Portfolio.getProject = (id) ->
            _currentProject = $portfolio.get({
                listController: 'projects'
                id: id
            })


        Portfolio.getProjects = ->
            Portfolio.loadProjects() if not Portfolio.projects
            Portfolio.projects


        Portfolio.currentProject = (project) ->
            if project
                _currentProject = project

            _currentProject


        Portfolio.getCurrentProjectCards = ->
            Cards.query
                id: _currentProject.id


        Portfolio.onProjectLoaded = ($scope, handle) ->
            console.log 'Portfolio.onProjectLoaded'

            $scope.$on PROJECTS_LOADED, (event, message) ->
                handle message


        # Save new project and insert it into `projects`
        Portfolio.saveProject = (data) ->
            project = new $portfolio data
            project.$save
                listController: 'projects'
                docController: 'save'
            , ->
                projects.push project


        Portfolio.updateProject = (project) ->
            project.$save
                listController: 'projects'
                docController: 'update'
            , (data) ->
                angular.forEach Portfolio.projects, (item) ->
                    if item.url is project.url
                        angular.extend item, project


        return Portfolio
    )
