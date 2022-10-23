<template>
  <div>
    <main-header>
      <a href="/">Scanner</a>
    </main-header>
    <div id="camera">
      <!-- <video ref="video" id="video" :width="videoWidth + 'px'" :height="videoHeight + 'px'" autoplay/> -->
      <video ref="video" id="video" autoplay/>
    </div>
    <div>
      <button id="snap" @click="capture()">Snap Photo</button>
      <!-- <input type="file" accept="image/*" capture/> -->
      <!-- <input type="file" id="imageFile" capture="camera" accept="image/*" /> -->
    </div>
    <h1>Canvas</h1>
    <!-- <canvas ref="canvas" id="canvas" width="100%" height="100%"/> -->
    <canvas ref="canvas" id="canvas" />
    <div>{{ captures }}</div>
    <img v-for="img in captures" :key="img" :src="img">
  </div>
</template>

<script>

export default {
  name: 'Profile',
  data() {
    return {
      video: {},
      canvas: {},
      captures: [],
      videoWidth: null,
      videoHeight: null,
    }
  },
  mounted() {
    this.videoWidth = window.innerWidth;
    this.videoHeight = window.innerHeight;

    window.addEventListener('resize', () => {
      this.videoWidth = window.innerWidth;
      this.videoHeight = window.innerHeight;
    });

    this.video = this.$refs.video;
    if(navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
        navigator.mediaDevices.getUserMedia({video: { facingMode: "environment" }}).then(stream => {
          this.video.srcObject = stream;
            this.video.play();
            this.video.onplay = function () {
            };
            this.video.play();
        });
    }
},
  methods: {
    capture() {
        this.canvas = this.$refs.canvas;
        this.canvas.width = this.video.clientWidth;
        this.canvas.height = this.video.clientHeight;
        this.canvas.getContext("2d").drawImage(this.video, 0, 0, this.video.offsetWidth, this.video.offsetHeight);
        this.captures.push(this.canvas.toDataURL("image/png"));
        this.addSpecificFileToDirectory();
    },
    // addSpecificFileToDirectory() {
    //   const data = this.captures[0].replace(/^data:image\/\w+;base64,/, "");
    //   const buf = new Buffer(data, 'base64');
    //   fs.writeFile('image.png', buf,function(err, result) {
    //     if(err){console.log('error', err);}
    //   });
    // }
}
}
</script>

<style>
    #camera {
      height: calc(100vh - 240px);
      display: flex;
      align-items: center;
      justify-content: center;
    }
    #video {
      background-color: #000000;
      max-width: 100%;
    }
    #canvas {
        display: none;
    }
</style>