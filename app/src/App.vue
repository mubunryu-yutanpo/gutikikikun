<template>
  <!--  <img alt="Vue logo" src="./assets/logo.png">-->
  <MyPage />
</template>

<script>
import MyPage from './components/MyPage.vue'

export default {
  name: 'App',
  components: {
    MyPage
  }
}
</script>

<style>
body{
  margin: 0;
  padding: 0;
}
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  //text-align: center;
  //color: #2c3e50;
  //margin-top: 60px;
}
</style>