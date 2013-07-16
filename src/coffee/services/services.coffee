angular.module('portfolioApp')
    .factory 'Portfolio', ($resource, $rootScope) ->

        PROJECTS_LOADED = 'Projects loaded'


        _currentProject = null


        uri = 'http://127.0.0.1\\:5000/portfolio/:listController:id/:docController'
        $portfolio = $resource uri


        Portfolio = {
            projects: []
        }


        Portfolio.save = (model) ->
            model.$save {
                listController: 'projects'
                docController: 'save'
            }


        Portfolio.loadProjects = ->
            Portfolio.projects = $portfolio.query({
                listController: 'projects'
            }, (data)->
                $rootScope.$broadcast PROJECTS_LOADED, data
            )

        Portfolio.getProject = (id) ->
            _currentProject = $portfolio.get({
                listController: 'projects'
                docController: id
            })

        Portfolio.getProjects = ->
            Portfolio.loadProjects() if not Portfolio.projects.length
            Portfolio.projects

        Portfolio.currentProject = ->
            _currentProject


        Portfolio.onProjectLoaded = ($scope, handle) ->
            console.log 'Portfolio.onProjectLoaded'

            $scope.$on PROJECTS_LOADED, (event, message) ->
                handle message


        Portfolio.selectProject = (project) ->
            angular.forEach Portfolio.projects, (item) ->
                item.active = project is item
            return


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
