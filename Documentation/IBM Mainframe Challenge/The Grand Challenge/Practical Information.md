![logo](https://eliasdh.com/assets/media/images/logo-github.png)

# 💙🤍Practical Information🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Setup](#✨setup)
4. [🔗Links](#🔗links)

---

### 📝Assignment

**Welcome to The Grand Challenge**  
You have arrived. To say we’re impressed is an understatement. We hope you’re able to stop for a few moments and think about everything that you’ve accomplished, because it’s a lot to reflect on.  
Assuming you started with zero or limited experience, you learned:  
- REXX  
- JCL  
- COBOL  
- Python  
- Zowe CLI  
- Unix System Services  
- Bash shell  
- Z Open Automation Utilities  
- DFSMS commands  
- Data set fundamentals  
- Ansible  
- Docker  
- and probably quite a few more along the way.  

We hope you enjoyed not just seeing a mix of technologies, but seeing how they all connect together to enable and empower mainframers.

---

**Get Ready to Compete**  
There’s no way to get this far without demonstrating a very high degree of skill and talent. You’ve already demonstrated you’re a top-tier contestant, and The Grand Challenge is your chance to emerge victorious as an overall winner.

**The Challenge**  
Normally we describe a task we wanted you to perform, but this year we decided to put you in charge. Simply put: Come up with something AWESOME.  
Here are your instructions:  
Come up with your own great idea: Ideas come in all shapes and sizes. We want you to think of something you can build, using the mainframe technology available to you. It should be something that makes mainframers go “Wow, I want THAT on my systems!”. It needs to involve the mainframe and be demonstratable using the system that we’ve made available for these challenges.  
Need some help with where to start? Here are some cool ideas!  
- What about building some REXX that generates starter COBOL code based on your JCL?  
- Maybe you want to put together a nice dynamic dashboard to get relevant system information when you log in through USS?  
- Have you considered a Python script that turns JCL condition codes into Morse Code that blinks on a nearby Raspberry Pi?

Still stumped? Take a look through Twitter, LinkedIn, and the IBM Z and LinuxONE Community to see what people are talking about there, and don’t be afraid to reach out and ask for inspiration!

**Make it happen**  
Whether you choose to build entirely in REXX, or some shell scripts that get called through ZOUA, you’re in charge of what tools you use and how complex your creation gets.  
A word of advice...Keep it simple and solid. Better to make something that’s easy to use and works every time than something that’s confusing and unpredictable. Quality over quantity.

**Directions To Try It Out:**  
Describe as clearly and concisely as possible what steps we should take to try out your creation. If there’s a script we need to run as your user, we can log in as your user. If you’ve got an Ansible playbook or something that resides outside of the mainframe, you can put it somewhere in your data sets or home directory where we can download it.  
Be clear about where we should start, what we should expect to see, any necessary input, and any commands required to execute. The instructions should be clear enough that they can be followed by a person who also finished the Last Level of the contest, so you should spell out what commands need to be entered, but there’s no need to explain how to submit JCL or download a file, for example.

**Describe Your Creation**  
Tell us about what you made. You’re going to design a single-page flyer that tells us the following information, in your own style:  
1. What you call your creation  
2. What it does  
3. Why it’s AWESOME  

Use screenshots, graphics, big fancy text, whatever you like to get us excited about your fantastic creation. Being able to clearly illustrate your work is an *incredibly* important skill in business. People need to be excited about something before they’ll want to try it out, and they need to see it working before they know it’s worth telling others about.  
Coming up with an idea and making it a reality is going to involve some serious effort. Make sure it gets noticed and used the way you want it to by spending a portion of that time writing it up.

---

**Restrictions:**  
- **Title:** 100 characters  
- **Notes:** 500 characters  
- **Directions:** 1500 Characters  
- **Flyer:** 5MB in size, JPG, PNG, GIF file format  

---

Here’s a demonstration of the level of detail you should consider when writing up your work.

**Title:** Snapshot and Restore-o-Matic  
**Notes:** An Ansible playbook, with supporting Python code, which lets a user make “snapshots” of their progress through a challenge, saving any indicated changed data sets and members, then letting them restore to a known saved state later on, if they want to re-try a challenge from scratch or go back to a “known good state”.  
**Directions:** Download the Ansible playbooks titled “checkpoint” and “restore” from my USS home directory in /z/Z99999. When run, the checkpoint playbook will grab everything up in the INPUT, SOURCE, WORK, and JCL data sets, as well as user-created content in the USS home directory and back them up in a tarball with the current date and time. By default, the restore playbook seeks the newest backup and moves all of the data sets, members, files and folders back where they were at the time of backup.

---

**Judging**  
Your work will be judged looking at the following qualities:  
- **Creative Ideas:** Did the contestant find a novel application of the skills they learned? Did they think outside the box and do their own research into what people might be interested in?  
- **Impressive Implementation:** Did the contestant make good use of the tools and technology available to them? Is the solution as simple, foolproof, and intuitive as possible? Does this feel like a solution that could be used in production?  
- **Clear Instructions:** Did the contestant write instructions that anybody with a “Adv. Level” knowledge of mainframe could follow? If input or editing was required, how clearly was that conveyed? Was thought given to where to begin, how to enable any additional features, and how to verify correct usage?  
- **Compelling Flyer:** Did the flyer generate interest in the creation? Did it accurately represent what their work? Did they make good use within the limited space to make sure the most important aspects got highlighted?  

It is important that your idea be solely your own original idea.  
Good luck!

---

> The deadline for submission: **2024-12-31 23:49:00 UTC**.

- How to log in USS: `ssh z58577@204.90.115.200` - `Password: xxxxxxxxxx`

### ✨Setup

```bash
# Run the following script to start the dashboard
bash <(curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Documentation/IBM%20Mainframe%20Challenge/The%20Grand%20Challenge/dashboard.sh) # On host not the mainframe
```

> When you wanna run this script, make sure that your environment is set.
- `.zone/zowe.config.json` file is present. Your username and password must be included. Example:
```json
"profiles": {
    "zosmf": {
        "type": "zosmf",
        "properties": {
            "host": "204.90.115.200",
            "port": 10443,
            "user": "xxxxx",
            "password": "xxxxx"
        },
        "secure": []
    },
```	

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us [elias.dehondt@outlook.com](mailto:elias.dehondt@outlook.com).