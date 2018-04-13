<template>
<draggable :list="list" class="dragArea">
    <div v-for="element in list">{{element.name}}</div>
 </draggable>
</template>

<script>
// import draggable from 'vuedraggable';
export default {
    data() {
        return {
            list:[
                {name:"John"}, 
                {name:"Joao"}, 
                {name:"Jean"} 
                ]
        }
    }
}
</script>