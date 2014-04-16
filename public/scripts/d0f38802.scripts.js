"use strict";angular.module("loghApp",["ui.bootstrap","ngCookies","ngResource","ngSanitize","ngRoute"]).config(["$routeProvider",function(a){a.when("/",{templateUrl:"views/main.html",controller:"MainCtrl"}).otherwise({redirectTo:"/"})}]);var loghApp=angular.module("loghApp");loghApp.filter("reverse",function(){return function(a){return a.split("").reverse().join("")}}),loghApp.controller("MainCtrl",["$scope","$http","$window",function(a,b,c){a.choices=[{code:"edit-profile",desc:"Edit Profile"},{code:"sign-out",desc:"Sign Out"}],a.isCollapsed=!0,a.submit=function(){b.post("/api/sessions",a.user).success(function(b){c.sessionStorage.token=b.token,a.isAuthenticated=!0}).error(function(){delete c.sessionStorage.token,a.isAuthenticated=!1,a.message="Error: Invalid user or password"})},a.logout=function(){a.isAuthenticated=!1,delete c.sessionStorage.token},a.getLeagues=function(){b({url:"/api/seasons/9/leagues",method:"GET"}).success(function(a){alert(JSON.stringify(a))}).error(function(a){alert(JSON.stringify(a))})}}]),loghApp.factory("authInterceptor",["$rootScope","$q","$window",function(a,b,c){return{request:function(a){return a.headers=a.headers||{},c.sessionStorage.token&&(a.headers.Authorization=c.sessionStorage.token),a},responseError:function(a){return 401===a.status,b.reject(a)}}}]),loghApp.config(["$httpProvider",function(a){a.interceptors.push("authInterceptor")}]);