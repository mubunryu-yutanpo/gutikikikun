<template>
  <!--   header   -->
  <header class="header">
    愚痴聞きさん
  </header>

  <div class="layout">
    <main class="main">
      <!-- 出力エリア -->
      <div class="message-container">
        <div class="message-outputs">
          <div
              v-for="(item, index) in items"
              :key="index"
              :class="['message', item.type]"
          >
            <img :src="item.image" alt="" :class="['thumbnail', item.type]">
            <p :class="['message-text', item.type]">{{ item.message }}</p>
          </div>
        </div>

        <!-- 入力エリア -->
        <div class="input-wrap">
          <form @submit.prevent="addItem" class="form">
            <div class="input-container">
              <input type="text" v-model="inputValue" placeholder="テキストを入力してください" class="input-area">
              <button type="submit" :disabled="isLoading" class="submit">
                <img :src="buttonImage" alt="送信" class="submit-icon">
                <!--          {{ isLoading ? '送信中...' : '送信' }}-->
              </button>
            </div>
          </form>
        </div>

      </div>
    </main>

    <aside class="side">
      <a href="http://localhost:8080" class="side-button new-chat-button">New Chat</a>
      <button @click="fetchConversationHistory" class="side-button history-button">履歴を表示</button>

      <!-- 会話の履歴表示 -->
      <div class="histories">
        <div
            v-for="(conversation) in conversations"
            :key="conversation.id"
            class="conversation-item"
        >
          <p class="history-title">・{{ conversation.name || '新しいチャット' }}</p> <!-- 会話名を表示 -->
        </div>
      </div>

      <div class="footer">©︎ 愚痴聞きさん 2024</div>
    </aside>

  </div>
</template>

<script setup>
import { ref } from 'vue'
import axios from 'axios'
import partnerImage from '../assets/partner.png'
import userImage from '../assets/user.png'
import buttonImage from '../assets/button-icon.png'
import '../assets/css/mypage.css'

// 入力された内容を保持する変数
const inputValue = ref('')

// 入力されたデータのリスト
const items = ref([])

// 会話履歴を保持する変数
const conversations = ref([])

// ローディング状態の管理
const isLoading = ref(false)

// メッセージを追加する関数
const addItem = async () => {
  if (inputValue.value.trim() !== '') {
    const userInput = inputValue.value

    // 自分のメッセージを追加
    items.value.push({
      type: 'user',
      message: userInput,
      image: userImage,
    })

    inputValue.value = '' // 入力エリアをクリア
    isLoading.value = true

    try {
      const response = await axios.post(
          'http://localhost/v1/chat-messages', // エンドポイントURL
          {
            inputs: {},
            query: userInput, // ユーザーの質問内容
            response_mode: 'blocking', // レスポンスモード: 'blocking' or 'streaming'
            conversation_id: '', // 新しい会話の場合は空文字
            user: 'abc-123', // 任意のユーザーID
            files: [ // ファイルを送信する場合
              {
                type: 'image',
                transfer_method: 'remote_url',
                url: 'https://cloud.dify.ai/logo/logo-site.png',
              },
            ],
          },
          {
            headers: {
              Authorization: `Bearer app-p1zHmlJOGUsFhv4ftzOI8Oba`, // Dify APIキーを指定
              'Content-Type': 'application/json',
            },
          }
      )

      // Botの応答を追加
      const apiResponse = response.data.answer || '応答がありません'
      items.value.push({
        type: 'partner',
        message: `${apiResponse}`,
        image: partnerImage,
      })
    } catch (error) {
      console.error('APIエラー:', error)
      items.value.push({
        type: 'partner',
        message: '⚠️ エラーが発生しました',
        image: partnerImage,
      })
    } finally {
      isLoading.value = false
    }
  }
}

const fetchConversationHistory = async () => {
  isLoading.value = true // ローディング状態をtrueに
  try {
    const response = await axios.get(
        'http://localhost/v1/conversations',
        {
          params: {
            user: 'abc-123',
            last_id: '',
            limit: 20
          },
          headers: {
            Authorization: `Bearer app-p1zHmlJOGUsFhv4ftzOI8Oba`,
          }
        }
    )

    conversations.value = response.data.data // APIの会話履歴を conversations にセット
    console.log('会話履歴を取得しました:', conversations.value) // コンソールに出力
  } catch (error) {
    console.error('履歴の取得に失敗しました:', error)
    items.value.push({
      type: 'partner',
      message: '⚠️ 履歴の取得に失敗しました',
      image: partnerImage,
    })
  } finally {
    isLoading.value = false // ローディング状態を解除
  }
}


</script>
