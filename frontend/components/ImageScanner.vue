<template>
  <div>
    <div class="scanned-images">
      <img v-for="img in captures" :key="img" :src="img">
    </div>
    <div id="camera">
      <video  id="video" ref="video" autoplay/>
    </div>
    <canvas id="canvas" ref="canvas" />
    <button id="snap" @click="capture()">Scan ingredients</button>
    <div>
      <button>cancel</button>
      <button>Check Ingredients</button>
    </div>
  </div>
</template>

<script>

export default {
  name: 'ImageScanner',
  data() {
    return {
      video: {},
      canvas: {},
      captures: [],
      // videoWidth: null,
      // videoHeight: null,
    }
  },
  mounted() {
    // this.videoWidth = window.innerWidth;
    // this.videoHeight = window.innerHeight;

    // window.addEventListener('resize', () => {
    //   this.videoWidth = window.innerWidth;
    //   this.videoHeight = window.innerHeight;
    // });

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
    }
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