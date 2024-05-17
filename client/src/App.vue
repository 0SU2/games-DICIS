<template>
    <v-app>
        
        <v-app-bar
        app
        color="#000000"
        dark
        >
            <template>
                <v-list-item-avatar class="mr-3">
                    <v-img
                        @click="go_to_home()" 
                        src="./assets/logo_riot.png" 
                    ></v-img>
                </v-list-item-avatar>
                RIOT GAMES
            </template>
            
        </v-app-bar>
        
        <v-main>
            <router-view/>
            
        </v-main>
    </v-app>

</template>

<script>
import router from '@/router';

export default {
    name: 'App',

    
    data() {
        return {}
    },
    methods:{
        go_to_home() {
            if(this.currentRout === 'Login'){
                return;
            }
            router.push({path: '/'})
        }
    },
    components: { router },
    computed:{
        currentRout() {
            return this.$route.name;
        }
    }

};
</script>

<style lang="scss">
main{
    background-image: url("../src/assets/astero-20210516a.jpg");
    background-position: center;
    background-size: cover;
    background-repeat: no-repeat;
}
</style>
