// Create the Menu model.
var Menu = Spine.Model.sub();
Menu.configure("Menu", "contents");

// Persist model between page reloads.
Menu.extend(Spine.Model.Local);

// Instance methods
Menu.include({
	contentsAsJSON: function() {
        return JSON.parse(this.contents);
    }
});
