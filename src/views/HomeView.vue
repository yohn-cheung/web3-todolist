<template>
  <div class="home">
    <div v-if="!account" class="row justify-content-md-center">
      <div class="col-md-auto">
        <button @click="connectWallet">Connect Wallet</button>
      </div>
    </div>
    <section v-else>
      <div class="row justify-content-md-center" v-if="!isLoading">
        <div class="col-10">
          <input
            class="py-3 form-control"
            placeholder="input your task"
            type="text"
            v-model="inputTodo"
          />
        </div>
        <div class="col-2">
          <button @click="createTask(inputTodo)" class="mt-3 btn btn-dark">Add</button>
        </div>
      </div>
      <div class="row" v-if="isLoading">
        <div class="text-center">
          <div class="spinner-border" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
        </div>
      </div>
      <div class="row" v-else>
        <div class="col-10">
          <ul class="list-group">
            <li
              class="list-group-item d-flex justify-content-between align-items-start"
              v-for="(task, index) in allTasks"
              :key="index"
            >
              <input
                class="form-check-input me-1"
                type="checkbox"
                v-model="task.completed"
                @change="toggleTask(task.id)"
              />
              <div class="ms-2 me-auto">
                <div :style="task.completed ? 'text-decoration: line-through;' : ''">
                  {{ task.content }}
                </div>
              </div>

              <div>
                <button
                  class="btn-sm btn btn-warning"
                  data-bs-toggle="modal"
                  data-bs-target="#exampleModal"
                  @click="passData(task.id, task.content)"
                >
                  Update Task
                </button>
                <button class="btn-sm btn btn-danger" @click="deleteTask(task.id)">
                  Delete
                </button>
              </div>
            </li>
          </ul>
        </div>
      </div>
    </section>

    <!-- Modal -->
    <div
      class="modal fade"
      id="exampleModal"
      tabindex="-1"
      aria-labelledby="exampleModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Update task</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <input type="text" v-model="dialogData.content" />
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
              Close
            </button>
            <button
              type="button"
              class="btn btn-primary"
              data-bs-dismiss="modal"
              @click="updateTask(dialogData.id, dialogData.content)"
            >
              Update new task
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ethers } from "ethers";
import contractABI from "../artifacts/contracts/TodoList.sol/TodoList.json";
const contractAddress = "0xC1c7862a236ba7258e2126faB3cEfd7F82931B41";

export default {
  name: "HomeView",
  data() {
    return {
      account: false,
      inputTodo: "",
      isLoading: false,
      allTasks: [],
      updateStatus: false,
      dialogData: {
        id: null,
        content: null,
      },
    };
  },
  created() {
    this.connectWallet();
  },
  methods: {
    passData(id, content) {
      this.dialogData.id = id;
      this.dialogData.content = content;
    },
    async connectWallet() {
      try {
        const { ethereum } = window;
        if (!ethereum) {
          alert("Must connect to MetaMask!");
          return;
        }
        const myAccounts = await ethereum.request({ method: "eth_requestAccounts" });

        console.log("Connected: ", myAccounts[0]);
        this.account = myAccounts[0];
      } catch (error) {
        console.log(error);
      }
    },
    async createTask(value) {
      if (value === "") return;
      try {
        const { ethereum } = window;
        if (ethereum) {
          // create provider object from ethers library, using ethereum object injected by metamask
          const provider = new ethers.providers.Web3Provider(ethereum);
          const signer = provider.getSigner();
          const todoContract = new ethers.Contract(
            contractAddress,
            contractABI.abi,
            signer
          );

          this.isLoading = true;

          const todoTxn = await todoContract.createTask(value);

          await todoTxn.wait();
          this.isLoading = false;
          this.inputTodo = "";
          this.getAllTasks();
        } else {
          console.log("Ethereum object doesn't exist!");
        }
      } catch (error) {
        console.log("error: ", error);
      }
    },
    async updateTask(id, content) {
      const taskIndex = this.allTasks.findIndex((task) => task.id == id);

      if (this.allTasks[taskIndex].content === content) {
        console.log("content is the same");
        return;
      }

      try {
        const { ethereum } = window;
        if (ethereum) {
          // create provider object from ethers library, using ethereum object injected by metamask
          const provider = new ethers.providers.Web3Provider(ethereum);
          const signer = provider.getSigner();
          const todoContract = new ethers.Contract(
            contractAddress,
            contractABI.abi,
            signer
          );

          this.isLoading = true;

          const todoTxn = await todoContract.updateTask(id, content);

          await todoTxn.wait();
          this.isLoading = false;
          this.dialogData.id = "";
          this.dialogData.content = "";
          this.getAllTasks();
        } else {
          console.log("Ethereum object doesn't exist!");
        }
      } catch (error) {
        console.log("error: ", error);
      }
    },
    async deleteTask(id) {
      try {
        const { ethereum } = window;
        if (ethereum) {
          // create provider object from ethers library, using ethereum object injected by metamask
          const provider = new ethers.providers.Web3Provider(ethereum);
          const signer = provider.getSigner();
          const todoContract = new ethers.Contract(
            contractAddress,
            contractABI.abi,
            signer
          );

          this.isLoading = true;

          const todoTxn = await todoContract.deleteTask(id);

          await todoTxn.wait();
          this.isLoading = false;
          this.getAllTasks();
        } else {
          console.log("Ethereum object doesn't exist!");
        }
      } catch (error) {
        console.log("error: ", error);
      }
    },
    async toggleTask(id) {
      try {
        const { ethereum } = window;
        if (ethereum) {
          // create provider object from ethers library, using ethereum object injected by metamask
          const provider = new ethers.providers.Web3Provider(ethereum);
          const signer = provider.getSigner();
          const todoContract = new ethers.Contract(
            contractAddress,
            contractABI.abi,
            signer
          );

          this.isLoading = true;

          const todoTxn = await todoContract.toggleCompleted(id);

          await todoTxn.wait();
          this.isLoading = false;
          this.getAllTasks();
        } else {
          console.log("Ethereum object doesn't exist!");
        }
      } catch (error) {
        console.log("error: ", error);
      }
    },
    async getAllTasks() {
      try {
        const { ethereum } = window;
        if (ethereum) {
          // create provider object from ethers library, using ethereum object injected by metamask
          const provider = new ethers.providers.Web3Provider(ethereum);
          const signer = provider.getSigner();
          const todoContract = new ethers.Contract(
            contractAddress,
            contractABI.abi,
            signer
          );

          const getAllTasks = await todoContract.getAllTasks();
          const tasks = [];

          getAllTasks.forEach((task) => {
            const object = {
              id: task.id,
              content: task.content,
              completed: task.completed,
              timestamp: task.timestamp,
            };
            tasks.push(object);
          });

          this.allTasks = tasks;
        } else {
          console.log("Ethereum object doesn't exist!");
        }
      } catch (error) {
        console.log("error: ", error);
      }
    },
  },
  watch: {
    account: {
      handler(newValue) {
        console.log("newValue: ", newValue);
        if (newValue !== false) {
          this.getAllTasks();
        }
      },
      deep: true,
    },
  },
};
</script>
