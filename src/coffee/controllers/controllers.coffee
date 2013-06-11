# Menu controller
PortfolioCtrl = ($scope, Portfolio) ->
    $scope.list = Portfolio.getProjects()
    return

PortfolioCtrl.$inject = ['$scope', 'Portfolio']
angular.module('portfolioNgApp').controller 'PortfolioCtrl', PortfolioCtrl


# List project's cards
CardListCtrl = ($scope, $routeParams, baseUrl, Portfolio) ->
    projectId = parseInt $routeParams.id, 10


    $scope.baseUrl = baseUrl
    $scope.cards = Portfolio.getCards projectId
    $scope.project = Portfolio.selectedProject()


    Portfolio.onProjectLoaded $scope, (projects) ->
        angular.forEach projects, (project) ->
            if project.id is projectId
                $scope.project = Portfolio.selectProject project


    return


CardListCtrl.$inject = ['$scope', '$routeParams', 'baseUrl', 'Portfolio']
angular.module('portfolioNgApp').controller 'CardListCtrl', CardListCtrl


# Edit project
ProjectEditCtrl = ($scope, Portfolio) ->
    $scope.project = Portfolio.selectedProject()

    $scope.save = ->
        Portfolio.save $scope.project

    return


ProjectEditCtrl.$inject = ['$scope', 'Portfolio']
angular.module('portfolioNgApp').controller 'ProjectEditCtrl', ProjectEditCtrl
