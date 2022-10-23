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
      this.writeToCloudinary(this.canvas.toDataURL("image/png"));
    },
    base64toBlob(base64Data, contentType) {
      contentType = contentType || '';
      const sliceSize = 1024;
      const byteCharacters = atob(base64Data);
      const bytesLength = byteCharacters.length;
      const slicesCount = Math.ceil(bytesLength / sliceSize);
      const byteArrays = new Array(slicesCount);

      for (let sliceIndex = 0; sliceIndex < slicesCount; ++sliceIndex) {
          const begin = sliceIndex * sliceSize;
          const end = Math.min(begin + sliceSize, bytesLength);

          const bytes = new Array(end - begin);
          for (let offset = begin, i = 0; offset < end; ++i, ++offset) {
              bytes[i] = byteCharacters[offset].charCodeAt(0);
          }
          byteArrays[sliceIndex] = new Uint8Array(bytes);
      }
      return new Blob(byteArrays, { type: contentType });
    },
    writeToCloudinary(base64) {
      // const url = "https://api.cloudinary.com/v1_1/fc-wiesendangen/image/upload";
      const url = "https://api.imagga.com/v2/tags";
      // const uploadPreset = "baselhack_preset";
      // const base64Data = (dataURL) => dataURL.split(',')[1];
      // const blob = this.base64toBlob('iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3/OAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVEiJtZZPbBtFFMZ/M7ubXdtdb1xSFyeilBapySVU8h8OoFaooFSqiihIVIpQBKci6KEg9Q6H9kovIHoCIVQJJCKE1ENFjnAgcaSGC6rEnxBwA04Tx43t2FnvDAfjkNibxgHxnWb2e/u992bee7tCa00YFsffekFY+nUzFtjW0LrvjRXrCDIAaPLlW0nHL0SsZtVoaF98mLrx3pdhOqLtYPHChahZcYYO7KvPFxvRl5XPp1sN3adWiD1ZAqD6XYK1b/dvE5IWryTt2udLFedwc1+9kLp+vbbpoDh+6TklxBeAi9TL0taeWpdmZzQDry0AcO+jQ12RyohqqoYoo8RDwJrU+qXkjWtfi8Xxt58BdQuwQs9qC/afLwCw8tnQbqYAPsgxE1S6F3EAIXux2oQFKm0ihMsOF71dHYx+f3NND68ghCu1YIoePPQN1pGRABkJ6Bus96CutRZMydTl+TvuiRW1m3n0eDl0vRPcEysqdXn+jsQPsrHMquGeXEaY4Yk4wxWcY5V/9scqOMOVUFthatyTy8QyqwZ+kDURKoMWxNKr2EeqVKcTNOajqKoBgOE28U4tdQl5p5bwCw7BWquaZSzAPlwjlithJtp3pTImSqQRrb2Z8PHGigD4RZuNX6JYj6wj7O4TFLbCO/Mn/m8R+h6rYSUb3ekokRY6f/YukArN979jcW+V/S8g0eT/N3VN3kTqWbQ428m9/8k0P/1aIhF36PccEl6EhOcAUCrXKZXXWS3XKd2vc/TRBG9O5ELC17MmWubD2nKhUKZa26Ba2+D3P+4/MNCFwg59oWVeYhkzgN/JDR8deKBoD7Y+ljEjGZ0sosXVTvbc6RHirr2reNy1OXd6pJsQ+gqjk8VWFYmHrwBzW/n+uMPFiRwHB2I7ih8ciHFxIkd/3Omk5tCDV1t+2nNu5sxxpDFNx+huNhVT3/zMDz8usXC3ddaHBj1GHj/As08fwTS7Kt1HBTmyN29vdwAw+/wbwLVOJ3uAD1wi/dUH7Qei66PfyuRj4Ik9is+hglfbkbfR3cnZm7chlUWLdwmprtCohX4HUtlOcQjLYCu+fzGJH2QRKvP3UNz8bWk1qMxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII=');
      const formdata = new FormData();
      
      // formdata.append("file", blob);
      // formdata.append("upload_preset", uploadPreset);
      formdata.append('image_base64', base64);
      formdata.append('limit', 1);

      fetch(url, {
        method: "POST",
        headers: {Authorization: 'Basic YWNjXzY2N2FlNDMyMWZiNTQyNTo5YTIyYmQ2ZTYwZGQzMDRkN2ZiMmM1YWNjZTM0Yjc4MQ=='},
        body: formdata,
      })
      .then((response) => {
        return response.json();
      })
      .then((data) => {
        const preferredTag = data.result.tags[0].tag.en ;
        console.log(preferredTag);
        this.$emit('image-scanned', this.$event, preferredTag);
      })
      .catch(error => {
        console.error(error);
      });
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