# Menu controller
PortfolioCtrl = ($scope, Portfolio) ->
    #$scope.list = Portfolio.getProjects()
    return

PortfolioCtrl.$inject = ['$scope', 'Portfolio']
angular.module('portfolioApp').controller 'PortfolioCtrl', PortfolioCtrl


# List project's cards
CardListCtrl = ($scope, $routeParams, baseUrl, Portfolio) ->
    projectId = parseInt $routeParams.id, 10

    $scope.baseUrl = baseUrl

    $scope.project = Portfolio.getProject projectId

    #Portfolio.onProjectLoaded $scope, (projects) ->
        #angular.forEach projects, (project) ->
            #if project.id is projectId
                #$scope.project = Portfolio.selectProject project

    return


CardListCtrl.$inject = ['$scope', '$routeParams', 'baseUrl', 'Portfolio']
angular.module('portfolioApp').controller 'CardListCtrl', CardListCtrl


# Edit project
ProjectEditCtrl = ($scope, Portfolio) ->
    $scope.project = Portfolio.currentProject()

    $scope.save = ->
        Portfolio.updateProject $scope.project

    return


ProjectEditCtrl.$inject = ['$scope', 'Portfolio']
angular.module('portfolioApp').controller 'ProjectEditCtrl', ProjectEditCtrl


# New project
ProjectNewCtrl = ($scope, Portfolio) ->
    $scope.project = {}

    $scope.save = ->
        Portfolio.saveProject $scope.project

    return

ProjectNewCtrl.$inject = ['$scope', 'Portfolio']
angular.module('portfolioApp').controller 'ProjectNewCtrl', ProjectNewCtrl
