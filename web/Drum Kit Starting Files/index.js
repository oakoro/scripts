
$("button").on("click",function() {
    handleClick();

})

function handleClick() {
    alert("I've be clicked")
    
}

$("button").on("keydown", function(event) {
    $("h1").text(event.key);
})