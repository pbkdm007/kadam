
angular.module('streama').controller('registerCtrl', ['$anchorScroll', '$location', '$scope',
  function ($anchorScroll, $location, $scope) {

    //This function is copied and modified from the AngularJS documentation: https://docs.angularjs.org/api/ng/service/$anchorScroll
    $scope.gotoAnchor = function(x) {
        // call $anchorScroll() explicitly,
        // since $location.hash hasn't changed
        $anchorScroll();
    };

  }
]);
