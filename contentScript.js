// Generated by CoffeeScript 1.6.2
(function() {
  var ContentScript, WhenReady;

  ContentScript = (function() {
    function ContentScript() {}

    return ContentScript;

  })();

  WhenReady = (function() {
    function WhenReady(callback) {
      var next, self;

      this.callback = callback;
      next = this.ready;
      self = this;
      document.addEventListener('DOMContentLoaded', function(domEvent) {
        return document.body.onload = function(bodyEvent) {
          return next.apply(self, [domEvent, bodyEvent]);
        };
      }, false);
    }

    WhenReady.prototype.ready = function() {
      return this.callback.apply(this, []);
    };

    return WhenReady;

  })();

  this.listener = new WhenReady(function() {
    return console.log('Im ready');
  });

  this.contentScript = new ContentScript();

}).call(this);

/*
//@ sourceMappingURL=contentScript.map
*/