function alertMessage(text) {
    alert("a"+text+"a")
}

window.logger = (flutter_value) => {
    console.log({ js_context: this, flutter_value });
}