"use strict"

# Menu controller
MenuCtrl = ($scope, Menu) ->
    $scope.tree = Menu.getTree()
    return

MenuCtrl.$inject = ['$scope', 'Menu']
angular.module('portfolioNgApp').controller 'MenuCtrl', MenuCtrl


# List menu's cards
CardListCtrl = ($scope, $routeParams, Menu) ->
    menuId = parseInt $routeParams.menuId, 10

    editMode = false
    localMenu = undefined

    $scope.isInEditMode = ->
        editMode

    $scope.editMode = () ->
        editMode = on
        localMenu = angular.copy $scope.menu
        return

    $scope.viewMode = ->
        angular.copy localMenu, $scope.menu
        editMode = off
        localMenu = undefined
        return

    $scope.save = (menu) ->
        Menu.save menu
        return

    $scope.menu = Menu.currentMenu

    currentIndex = 0;
    total = false

    $scope.cards = Menu.getCards menuId

    $scope.isLinkDisabled = (direction) ->
        result = false
        if direction is 'previous' and currentIndex is 0
            result = true

        if direction is 'next' and currentIndex is total
            result = true

        result

    Menu.onMenuLoaded $scope, (menu) ->
        angular.forEach menu, (item) ->
            if item.id is menuId
                $scope.menu = item
            return

        return

    return

CardListCtrl.$inject = ['$scope', '$routeParams', 'Menu']
angular.module('portfolioNgApp').controller 'CardListCtrl', CardListCtrl
