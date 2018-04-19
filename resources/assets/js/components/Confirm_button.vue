    <!-- data-toggle="tooltip" -->
<template>
  <button
    v-tooltip="currentTooltipMessage"
    class="btn btn-xs pull-right"
    :class="[ css, currentStep == lastMessageIndex - 1? 'btn-success' : 'btn-danger' ]"
    v-on:click='incrementStep()'>
    <i :class="currentMessage"></i>
  </button>
</template>

<script>
  export default {
    name: 'confirm-button',
    props: {
      messages: Array,
      css: {
        type: String,
        default: ''
      },
    },
    data() {
      return {
        defaultSteps: [
          'fa fa-times',
          'fa fa-check'
        ],
        currentStep: 0,
        tooltipMessages: [
          'Retirar estudiante',
          'Confirmar retiro'
        ]
      }
    },
    computed: {
      messageList() {
        return this.messages ? this.messages : this.defaultSteps
      },
      currentMessage() {
        return this.messageList[this.currentStep]
      },
      currentTooltipMessage() {
        return this.tooltipMessages[this.currentStep]
      },
      lastMessageIndex() {
        return this.messageList.length
      },
      stepsComplete() {
        return this.currentStep === this.lastMessageIndex
      }
    },
    methods: {
      incrementStep() {
        this.currentStep++
        if (this.stepsComplete) {
          this.$emit('confirmation-success');
          this.reset();
        }
        else {
          this.$emit('confirmation-incremented')
        }
      },
      reset() {
        this.currentStep = 0
        this.$emit('confirmation-reset')
      },
    },
  }
</script>
