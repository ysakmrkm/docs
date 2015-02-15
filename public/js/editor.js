var Editor, id;

Editor = function(input, preview) {
  this.update = function() {
    return preview.innerHTML = markdown.toHTML(input.value);
  };
  input.editor = this;
  return this.update();
};

id = function(id) {
  return document.getElementById(id);
};

new Editor(id("markdown"), id("preview"));

$(function() {
  $(".dropdown-button").dropdown({
    hover: false,
    constrain_width: 1000,
    alignment: 'right',
    belowOrigin: true
  });
});

//# sourceMappingURL=editor.js.map