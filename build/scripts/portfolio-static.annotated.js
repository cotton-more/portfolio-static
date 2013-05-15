(function (window, angular, undefined) {
  'use strict';
  var CardListCtrl, MenuCtrl;
  angular.module('portfolioNgApp', ['ngResource']).config([
    '$routeProvider',
    '$locationProvider',
    function ($route, $location) {
      $route.when('/', { templateUrl: '/views/index.html' }).when('/menu/:menuId/edit', {
        templateUrl: '/views/menu_edit.html',
        controller: 'MenuEditCtrl'
      }).when('/menu/:menuId/cards', {
        templateUrl: '/views/menu_cards.html',
        controller: 'CardListCtrl'
      }).otherwise({ redirectTo: '/' });
      return $location.html5Mode(false).hashPrefix('!');
    }
  ]);
  'use strict';
  MenuCtrl = function ($scope, Menu) {
    $scope.tree = Menu.getTree();
  };
  MenuCtrl.$inject = [
    '$scope',
    'Menu'
  ];
  angular.module('portfolioNgApp').controller('MenuCtrl', MenuCtrl);
  CardListCtrl = function ($scope, $routeParams, Menu) {
    var currentIndex, editMode, localMenu, menuId, total;
    menuId = parseInt($routeParams.menuId, 10);
    editMode = false;
    localMenu = void 0;
    $scope.isInEditMode = function () {
      return editMode;
    };
    $scope.editMode = function () {
      editMode = true;
      localMenu = angular.copy($scope.menu);
    };
    $scope.viewMode = function () {
      angular.copy(localMenu, $scope.menu);
      editMode = false;
      localMenu = void 0;
    };
    $scope.save = function (menu) {
      Menu.save(menu);
    };
    $scope.menu = Menu.currentMenu;
    currentIndex = 0;
    total = false;
    $scope.cards = Menu.getCards(menuId);
    $scope.isLinkDisabled = function (direction) {
      var result;
      result = false;
      if (direction === 'previous' && currentIndex === 0) {
        result = true;
      }
      if (direction === 'next' && currentIndex === total) {
        result = true;
      }
      return result;
    };
    Menu.onMenuLoaded($scope, function (menu) {
      angular.forEach(menu, function (item) {
        if (item.id === menuId) {
          $scope.menu = item;
        }
      });
    });
  };
  CardListCtrl.$inject = [
    '$scope',
    '$routeParams',
    'Menu'
  ];
  angular.module('portfolioNgApp').controller('CardListCtrl', CardListCtrl);
  angular.module('portfolioNgApp').directive('niPersonaAuth', [
    'Persona',
    '$compile',
    function (Persona, $compile) {
      var authTmpl, niPersonaAuth, userTmpl;
      authTmpl = '<a><img class="persona" ng-click="request()" src="images/plain_sign_in_black.png"></a>';
      userTmpl = '<a>{{email}} <span ng-click="signout()" class="button">Sign out</span></a>';
      niPersonaAuth = {
        template: '<li class="persona"><a>Persona</a></li>',
        restrict: 'M',
        replace: true
      };
      niPersonaAuth.link = function (scope, element) {
        scope.request = function () {
          return Persona.request();
        };
        scope.signout = function () {
          return Persona.signout();
        };
        return Persona.onStatus(scope, function (message) {
          var template;
          if (message.email) {
            scope.email = message.email;
            template = userTmpl;
          } else {
            template = authTmpl;
          }
          element.html(template);
          return $compile(element.contents())(scope);
        });
      };
      return niPersonaAuth;
    }
  ]);
  angular.module('portfolioNgApp').directive('niCard', [function () {
      var niCard, template;
      template = '<div class="card">\n    <h4 class="title">{{card.name}}</h4>\n    <img src="http://placehold.it/600x480/&text={{card.name}}">\n    <p>{{card.about}}</p>\n</div>';
      niCard = {
        restrict: 'M',
        replace: true,
        template: template,
        link: function (scope) {
          if (scope.$last) {
            return $('#cards-list').foundation('orbit', {
              bullets: false,
              slide_number: false
            });
          }
        }
      };
      return niCard;
    }]);
  angular.module('portfolioNgApp').directive('niMenu', [function () {
      var niMenu;
      niMenu = {
        template: '<ul>\n    <li data-ng-repeat="item in tree">\n        <!-- directive: ni-menu-item item -->\n    </li>\n</ul>',
        replace: true,
        restrict: 'M',
        scope: { tree: '=niMenu' }
      };
      return niMenu;
    }]);
  angular.module('portfolioNgApp').directive('niMenuItem', [
    '$compile',
    'Menu',
    function ($compile, Menu) {
      var linker, niMenuItem, selectMenuElement;
      selectMenuElement = function (item) {
        Menu.currentMenu = item;
      };
      linker = function (scope, elm) {
        var childitem;
        scope.select = selectMenuElement;
        if (scope.item.children.length) {
          childitem = $compile('<!-- directive: ni-menu item.children -->')(scope);
          return elm.append(childitem);
        }
      };
      niMenuItem = {
        restrict: 'M',
        replace: true,
        template: '<span><a ng-href="#!/menu/{{item.id}}/cards" ng-click="select(item)">{{item.name}}</a></span>',
        link: linker
      };
      return niMenuItem;
    }
  ]);
  angular.module('portfolioNgApp').factory('Persona', [
    '$http',
    '$rootScope',
    function ($http, $rootScope) {
      var Persona, STATUS, _email, _status;
      STATUS = 'Email of logged in user';
      _email = void 0;
      _status = function () {
        console.log('_status');
        return $http.jsonp('http://localhost:8000/auth/email?callback=JSON_CALLBACK').success(function (data) {
          console.log('get email', data);
          $rootScope.$broadcast(STATUS, data);
          return navigator.id.watch({
            loggedInUser: data.email,
            onlogin: function (assertion) {
              console.log('onlogin');
              return $http.jsonp('http://localhost:8000/auth/login', {
                params: {
                  callback: 'JSON_CALLBACK',
                  assertion: assertion
                }
              }).success(function (data) {
                console.log('verifyAssertion.success', data);
                return $rootScope.$broadcast(STATUS, data);
              });
            },
            onlogout: function () {
              console.log('onlogout');
              return $http.jsonp('http://localhost:8000/auth/logout?callback=JSON_CALLBACK').success(function (data) {
                console.log('auth/logout', data);
                return $rootScope.$broadcast(STATUS, data);
              });
            }
          });
        });
      };
      Persona = {};
      Persona.onStatus = function ($scope, handle) {
        console.log('Persona.onStatus', arguments);
        $scope.$on(STATUS, function (event, message) {
          console.log('Persona.onStatus.$on', arguments);
          _email = message.email;
          return handle(message);
        });
        return _status();
      };
      Persona.request = function () {
        console.log('request');
        return navigator.id.request();
      };
      Persona.signout = function () {
        console.log('signout');
        return navigator.id.logout();
      };
      Persona.email = function () {
        return _email;
      };
      return Persona;
    }
  ]);
  angular.module('portfolioNgApp').factory('User', [
    '$http',
    '$rootScope',
    function ($http) {
      var User, authToken, isAuthenticated;
      authToken = null;
      isAuthenticated = false;
      User = {};
      User.getEmail = function () {
        return 'vansanblch@gmail.com';
      };
      User.isAuthenticated = function () {
        return isAuthenticated;
      };
      User.login = function () {
        return $http.post;
      };
      return User;
    }
  ]);
  angular.module('portfolioNgApp').factory('Menu', [
    '$resource',
    '$http',
    '$rootScope',
    function ($resource, $http, $rootScope) {
      var CARDS_LOADED, MenuService, TREE_LOADED, keepGoing, menu, pushChild, tree;
      keepGoing = true;
      tree = [];
      menu = [];
      MenuService = { currentMenu: false };
      TREE_LOADED = 'treeLoaded';
      CARDS_LOADED = 'cardsLoaded';
      pushChild = function (item, to) {
        if (to == null) {
          to = tree;
        }
        if (item.parent_id === null) {
          return to.push(item);
        } else {
          return angular.forEach(to, function (value) {
            if (keepGoing) {
              if (value.id === item.parent_id) {
                keepGoing = false;
                return value.children.push(item);
              } else {
                return pushChild(item, value.children);
              }
            }
          });
        }
      };
      MenuService.getTree = function () {
        var uri;
        if (tree.length) {
          return tree;
        }
        uri = 'http://localhost\\:5000/menu/:action';
        $resource(uri).query({ action: 'list' }, function (data) {
          menu = data.result;
          angular.forEach(data.result, function (item) {
            item.children = [];
            keepGoing = true;
            return pushChild(item);
          });
          return $rootScope.$broadcast(TREE_LOADED, menu);
        });
        return tree;
      };
      MenuService.onMenuLoaded = function ($scope, handle) {
        return $scope.$on(TREE_LOADED, function (event, message) {
          return handle(message);
        });
      };
      MenuService.onCardsLoaded = function ($scope, handle) {
        return $scope.$on(CARDS_LOADED, function (event, message) {
          return handle(message);
        });
      };
      MenuService.getCards = function (menuId, callback) {
        if (!angular.isFunction(callback)) {
          callback = angular.noop;
        }
        return $resource('http://localhost\\:8000/get_cards/:menuId', { callback: 'JSON_CALLBACK' }, { query: { method: 'JSONP' } }).query({ menuId: menuId }, callback);
      };
      MenuService.save = function (menu) {
        var menuId;
        menuId = menu.id;
        return $http.jsonp('http://localhost\\:8000/menu/:id/save', {
          id: 'test',
          params: menu
        });
      };
      return MenuService;
    }
  ]);
}(window, window.angular));