angular.module('portfolioApp.controllers', [])
    # Menu controller
    .controller('PortfolioCtrl', [ -> ])


    # List project's cards
    .controller('CardListCtrl', [
        '$scope'
        '$routeParams'
        'baseUrl'
        'Portfolio'
        ($scope, $routeParams, baseUrl, Portfolio) ->
            $scope.project = Portfolio.currentProject()
            $scope.cards = Portfolio.getCurrentProjectCards()
    ])


    # Edit project
    .controller('ProjectEditCtrl', [
        '$scope'
        'Portfolio'
        ($scope, Portfolio) ->
            $scope.project = Portfolio.currentProject()

            $scope.save = ->
                Portfolio.updateProject $scope.project

            return
    ])


    # New project
    .controller('ProjectNewCtrl', [
        '$scope'
        'Portfolio'
        ($scope, Portfolio) ->
            $scope.project = {}

            $scope.save = ->
                Portfolio.saveProject $scope.project

            return
    ])
