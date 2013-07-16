angular.module('portfolioApp')
    .factory 'Portfolio', ($resource, $rootScope) ->

        PROJECTS_LOADED = 'Projects loaded'


        projects = []
        _currentProject = null


        uri = 'http://127.0.0.1\\:5000/portfolio/:listController:id/:docController'
        $portfolio = $resource uri


        Portfolio = {}


        Portfolio.save = (model) ->
            model.$save {
                listController: 'projects'
                docController: 'save'
            }


        Portfolio.getProjects = ->
            projects = $portfolio.query({
                listController: 'projects'
            }, (data)->
                $rootScope.$broadcast PROJECTS_LOADED, data
            )

        Portfolio.getProject = (id) ->
            _currentProject = $portfolio.get({
                listController: 'projects'
                docController: id
            })


        Portfolio.currentProject = ->
            _currentProject


        Portfolio.onProjectLoaded = ($scope, handle) ->
            console.log 'Portfolio.onProjectLoaded'

            $scope.$on PROJECTS_LOADED, (event, message) ->
                handle message


        Portfolio.selectProject = (project) ->
            angular.forEach projects, (item) ->
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



        return Portfolio
