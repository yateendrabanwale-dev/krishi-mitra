const cropGuides = {
  Tomato: {
    seed: "120 g seed per acre",
    fertilizer: "Use compost before transplanting, then split nitrogen in 3 doses.",
    water: "Keep soil evenly moist; avoid water on leaves in the evening."
  },
  Rice: {
    seed: "20 kg seed per acre",
    fertilizer: "Apply basal phosphorus and split nitrogen at tillering and panicle stages.",
    water: "Maintain shallow standing water after establishment."
  },
  Wheat: {
    seed: "40 kg seed per acre",
    fertilizer: "Use balanced NPK at sowing and top dress nitrogen after first irrigation.",
    water: "Irrigate at crown root, tillering, and grain filling stages."
  },
  Maize: {
    seed: "8 kg seed per acre",
    fertilizer: "Add farmyard manure and split nitrogen between sowing and knee-high stage.",
    water: "Do not allow stress during tasseling and cob formation."
  },
  Cotton: {
    seed: "1.5 kg seed per acre",
    fertilizer: "Use potash-rich nutrition and avoid excess nitrogen.",
    water: "Irrigate deeply but less often; prevent waterlogging."
  }
};

const soilNotes = {
  Loamy: "Loamy soil is ideal for balanced drainage and nutrient holding.",
  Clay: "Clay soil holds water longer, so reduce irrigation frequency.",
  Sandy: "Sandy soil drains quickly, so use mulch and smaller irrigation rounds.",
  "Black soil": "Black soil holds moisture well and suits cotton and pulses."
};

const tasks = [
  { title: "Check drip lines in tomato field", done: false },
  { title: "Buy bio-fertilizer for nursery", done: false },
  { title: "Record market price before harvest sale", done: true }
];

const prices = [
  { crop: "Tomato", price: "Rs. 1,850 / quintal", trend: "+6%", up: true },
  { crop: "Rice", price: "Rs. 2,220 / quintal", trend: "+2%", up: true },
  { crop: "Wheat", price: "Rs. 2,410 / quintal", trend: "-1%", up: false },
  { crop: "Maize", price: "Rs. 2,050 / quintal", trend: "+3%", up: true }
];

const diagnosisText = {
  curl: "Likely cause: whitefly or leaf curl virus. Remove heavily affected plants, place yellow sticky traps, and consult a local agriculture officer before spraying.",
  spots: "Likely cause: fungal leaf spot. Remove infected leaves, improve spacing, and avoid overhead watering.",
  yellow: "Likely cause: nitrogen deficiency or poor drainage. Check soil moisture first, then apply balanced nutrition if roots are healthy.",
  holes: "Likely cause: caterpillars or beetles. Inspect leaf undersides in the evening and use pheromone traps where suitable."
};

const plannerForm = document.querySelector("#plannerForm");
const adviceBox = document.querySelector("#adviceBox");
const taskList = document.querySelector("#taskList");
const priceList = document.querySelector("#priceList");
const symptom = document.querySelector("#symptom");
const diagnosis = document.querySelector("#diagnosis");
const toast = document.querySelector("#toast");

function showToast(message) {
  toast.textContent = message;
  toast.classList.add("show");
  window.setTimeout(() => toast.classList.remove("show"), 2200);
}

function renderTasks() {
  taskList.innerHTML = "";
  tasks.forEach((task, index) => {
    const item = document.createElement("li");
    const checkbox = document.createElement("input");
    const title = document.createElement("span");
    const due = document.createElement("small");

    checkbox.type = "checkbox";
    checkbox.checked = task.done;
    checkbox.addEventListener("change", () => {
      tasks[index].done = checkbox.checked;
      renderTasks();
    });

    title.className = `task-title${task.done ? " done" : ""}`;
    title.textContent = task.title;
    due.textContent = index === 0 ? "Today" : "This week";

    item.append(checkbox, title, due);
    taskList.append(item);
  });
}

function renderPrices() {
  priceList.innerHTML = "";
  prices.forEach((item) => {
    const row = document.createElement("div");
    const name = document.createElement("div");
    const value = document.createElement("strong");
    const trend = document.createElement("span");

    row.className = "price-row";
    name.textContent = item.crop;
    value.textContent = item.price;
    trend.className = item.up ? "trend-up" : "trend-down";
    trend.textContent = item.trend;

    row.append(name, value, trend);
    priceList.append(row);
  });
}

function updateDiagnosis() {
  diagnosis.textContent = diagnosisText[symptom.value];
}

plannerForm.addEventListener("submit", (event) => {
  event.preventDefault();
  const crop = document.querySelector("#crop").value;
  const area = Number(document.querySelector("#area").value || 0);
  const soil = document.querySelector("#soil").value;
  const guide = cropGuides[crop];

  adviceBox.innerHTML = `
    <strong>${crop} plan for ${area.toFixed(1)} acre${area === 1 ? "" : "s"}</strong><br>
    Seed: ${guide.seed}.<br>
    Fertilizer: ${guide.fertilizer}<br>
    Irrigation: ${guide.water}<br>
    Soil note: ${soilNotes[soil]}
  `;
  showToast("Crop advice generated");
});

document.querySelector("#resetPlanner").addEventListener("click", () => {
  plannerForm.reset();
  adviceBox.textContent = "Select your field details to get seed, fertilizer, and irrigation guidance.";
});

document.querySelector("#addTask").addEventListener("click", () => {
  tasks.unshift({ title: "New field inspection task", done: false });
  renderTasks();
  showToast("Task added");
});

document.querySelectorAll("[data-action]").forEach((button) => {
  button.addEventListener("click", () => showToast(`${button.dataset.action} saved`));
});

symptom.addEventListener("change", updateDiagnosis);

renderTasks();
renderPrices();
updateDiagnosis();
